class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, except: [:index, :search, :show]
  
  def index
    @posts = Post.where(reading_status: false)
    if params[:shop_genre].present?
      @posts = @posts.where(shop_genre: params[:shop_genre])
    end
    if params[:prefecture].present?
      @posts = @posts.where(prefecture: params[:prefecture])
    end
    if params[:sort_rule] == "0"
      @posts = @posts.order(id: :desc)
    elsif params[:sort_rule] == "1"
      @posts = @posts.order(id: :asc)
    elsif params[:sort_rule] == "2"
      @posts = @posts.order(rate: :desc)
    elsif params[:sort_rule] == "3"
      @posts = @posts.includes(:favorites).sort{|a,b| b.favorites.size <=> a.favorites.size }
    end
    
  end
  
  def search
    session[:shop_name] = params[:shop_name]
    @posts = Post.where(reading_status: false).where("shop_name LIKE?", "%#{session[:shop_name]}%")
    if params[:shop_genre].present?
      @posts = @posts.where(shop_genre: params[:shop_genre])
    end
    if params[:prefecture].present?
      @posts = @posts.where(prefecture: params[:prefecture])
    end
    if params[:sort_rule].present?
      Post.sort_branch(@posts, params[:sort_rule])
    end
    @posts = @posts.page(params[:page])
  end
  
  def new
    @post = Post.new
  end
  
  def tag_select
    @post = Post.new(post_params)
    session[:new_post] = @post
    # 一時ファイルの作成。一時ファイルへのパスをsessionに格納
    @temp_files = []
    temp_file_dir = Rails.root.join('tmp', 'uploads') # ディレクトリを調整してください
    FileUtils.mkdir_p(temp_file_dir) # ディレクトリが存在しない場合に作成
    params[:post][:post_images].each_with_index do |image, index|
      temp_file = Tempfile.new("tempfile_#{index}", temp_file_dir)
      temp_file.binmode
      temp_file.write(image.read)
      temp_file.rewind
      @temp_files << temp_file
    end
    session[:temporary_image_pathes] = @temp_files.map(&:path)
    redirect_to tag_select_display_posts_path
  end
  
  def tag_select_display
    @post = Post.new(session[:new_post])
    @tags = Tag.where(is_available: false).order(:name)
    @tag = Tag.new
  end
   
  def preview
    @post = Post.new(session[:new_post])
    @tags = Tag.where(id: params[:tag_ids])
    session[:tag_ids] = params[:tag_ids]
    # ディスク上のディレクトリから一時ファイルを読み込む
    @temp_image_pathes = session[:temporary_image_pathes]
    @tmp_images=[]
    @temp_image_pathes.each do |image_path|
      # file_data = File.read(image_path)ファイルを消してしまう記述？
      file_data = File.open(image_path, File::RDONLY){|file| file.read}
      @tmp_images << Base64.strict_encode64(file_data)
    end
    
  end

  def create
    @post = Post.new(session[:new_post])
    @temp_image_pathes = session[:temporary_image_pathes]
    @temp_image_pathes.each do |image_path|
      file = File.open(image_path)
      blob = ActiveStorage::Blob.create_after_upload!(
        io: file,
        filename: File.basename(image_path),
        content_type: 'image/jpeg'
        )
      @post.post_images.attach(blob)
    end
    @tags = Tag.where(id: session[:tag_ids])
    @post.save
    @tags.each do |tag|
      tagging = Tagging.new
      tagging.post_id = @post.id
      tagging.tag_id = tag.id
      tagging.save
    end
    session.delete(:new_post)
    session.delete(:tag_ids)
    session.delete(:temporary_image_pathes)
    redirect_to post_path(@post.id)
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @comments = @post.comments.where(reading_status: false, top_parent_id: nil)
    @comment = Comment.new
    @reply = Comment.new
  end

  def edit
    @post = Post.find(params[:id])
  end
  
  def edit_tag
    @post = Post.find(params[:id])
    session[:post_params] = edit_post_params
    # 投稿内の画像を変更する場合
    if params[:post][:post_images].present?
      @temp_files = []
      temp_file_dir = Rails.root.join('tmp', 'uploads') # ディレクトリを調整してください
      FileUtils.mkdir_p(temp_file_dir) # ディレクトリが存在しない場合に作成
      params[:post][:post_images].each_with_index do |image, index|
        temp_file = Tempfile.new("tempfile_#{index}", temp_file_dir)
        temp_file.binmode
        temp_file.write(image.read)
        temp_file.rewind
        @temp_files << temp_file
      end
      session[:temporary_image_pathes] = @temp_files.map(&:path)
    end
    redirect_to edit_tag_display_post_path(@post.id)
  end
  
  def edit_tag_display
    @post = Post.find(params[:id])
    @selected_tags = @post.tags.all
    @tags = Tag.where(is_available: false).order(:name)
    @tag = Tag.new
  end
  
  def edit_preview
    
    @post = Post.find(params[:id])
    @editted_post = Post.new(session[:post_params])
    if params[:tag_ids].present?
      @tags = Tag.where(id: params[:tag_ids])
      session[:new_tag_ids] = params[:tag_ids]
    else
      @tags = @post.tags.all
    end
    # 投稿内の画像を変更する場合
    if session[:temporary_image_pathes].present?
      @temp_image_pathes = session[:temporary_image_pathes]
      @tmp_images=[]
      @temp_image_pathes.each do |image_path|
        
        # file_data = File.read(image_path)ファイルを消してしまう記述？
        file_data = File.open(image_path, File::RDONLY){|file| file.read}
        @tmp_images << Base64.strict_encode64(file_data)
      end
    end
  end
  
  def update
    @post = Post.find(params[:id])
    @post.update(session[:post_params])
    # 画像の変更を行う場合
    if session[:temporary_image_pathes].present?
      @post.post_images.each do |post_image|
        post_image.purge
      end
      @temp_image_pathes = session[:temporary_image_pathes]
      @temp_image_pathes.each do |image_path|
        file = File.open(image_path)
        blob = ActiveStorage::Blob.create_after_upload!(
          io: file,
          filename: File.basename(image_path),
          content_type: 'image/jpeg'
          )
        @post.post_images.attach(blob)
      end
    end
    if session[:tag_ids].present?
      @post.taggings.destroy_all
      @tags = Tag.where(id: session[:new_tag_ids])
      @tags.each do |tag|
        tagging = Tagging.new
        tagging.post_id = @post.id
        tagging.tag_id = tag.id
        tagging.save
      end
    end
    session.delete(:post_params)
    session.delete(:new_tag_ids)
    session.delete(:temporary_image_pathes)
    redirect_to post_path(@post.id)
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to user_path(current_user.id)
  end
  
  private
  
  def post_params
    params.require(:post).permit(:shop_name, :shop_genre, :prefecture, :address, :review, :rate, :reading_status, :user_id, post_images:[])
  end
  
  def edit_post_params
    params.require(:post).permit(:shop_name, :shop_genre, :prefecture, :address, :review, :rate, :reading_status, :user_id)
  end
  
end

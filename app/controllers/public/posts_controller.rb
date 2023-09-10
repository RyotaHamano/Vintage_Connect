class Public::PostsController < ApplicationController
  
  def index
    @posts = Post.where(reading_status: false)
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
    if session[:new_post]
      @post = Post.new(session[:new_post])
    else
      @post = Post.new
    end
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
    @tags = Tag.where(is_available: false)
    @tag = Tag.new
  end
  
  def preview
    @post = Post.new(session[:new_post])
    @tags = Tag.where(id: params[:tag_ids])
    session[:tag_ids] = params[:tag_ids]
    # ディスク上のディレクトリから一時ファイルを読み込む
    @temp_image_pathes = session[:temporary_image_pathes]
    @temp_image_pathes.each do |image_path|
      file_data = File.open(image_path, File::RDONLY){|file| file.read}
      blob = ActiveStorage::Blob.create_after_upload!(
        io: StringIO.new(file_data),
        filename: File.basename(image_path),
        content_type: 'image/jpeg'
        )
      @post.post_images.attach(blob)
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
    @comments = @post.comments.where(reading_status: false, top_parent_id: nil)
  end

  def edit
    @post = Post.find(params[:id])
  end
  
  def edit_tag
    @post = Post.find(params[:id])
    session[:post_params] = post_params
    redirect_to edit_tag_display_post_path(@post.id)
  end
  
  def edit_tag_display
    @post = Post.find(params[:id])
    @tags = Tag.where(is_available: false)
    @tag = Tag.new
  end
  
  def edit_preview
    @post = Post.find(params[:id])
    @editted_post = Post.new(session[:post_params])
    @tags = Tag.where(id: params[:tag_ids])
    session[:new_tag_ids] = params[:tag_ids]
  end
  
  def update
    @post = Post.find(params[:id])
    @post.update(session[:post_params])
    @post.taggings.destroy_all
    @tags = Tag.where(id: session[:new_tag_ids])
    @tags.each do |tag|
      tagging = Tagging.new
      tagging.post_id = @post.id
      tagging.tag_id = tag.id
      tagging.save
    end
    session.delete(:post_params)
    session.delete(:new_tag_ids)
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
  
end

class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, except: [:index, :search, :show]
  before_action :validate_post, only:[:tag_select]
  before_action :validate_edit_post, only:[:edit_tag]
  before_action :validate_post_images, only:[:tag_select, :edit_tag]
  before_action :validate_post_tags, only:[:preview, :edit_preview]
  #before_action :tmp_file_access, only:[:tag_select_display]

  def index
    if params[:sort_rule].present?
      @posts = Post.where(reading_status: false).ordered_sort(params[:sort_rule])
    else
      @posts = Post.where(reading_status: false).order(id: :desc)
    end
    if params[:shop_genre].present?
      @posts = @posts.where(shop_genre: params[:shop_genre])
    end
    if params[:prefecture].present?
      @posts = @posts.where(prefecture: params[:prefecture])
    end
    @posts = @posts.page(params[:page])
  end

  def search
    if params[:shop_name].present?
      session[:shop_name] = params[:shop_name]
    end
    if params[:sort_rule].present?
      @posts = Post.where(reading_status: false).where("shop_name LIKE?", "%#{session[:shop_name]}%").ordered_sort(params[:sort_rule])
    else
      @posts = Post.where(reading_status: false).where("shop_name LIKE?", "%#{session[:shop_name]}%").order(id: :desc)
    end
    if params[:shop_genre].present?
      @posts = @posts.where(shop_genre: params[:shop_genre])
    end
    if params[:prefecture].present?
      @posts = @posts.where(prefecture: params[:prefecture])
    end
    @posts = @posts.page(params[:page])
  end

  def new
    @post = Post.new
  end

  def tag_select
    @post = Post.new(post_params)
    session[:new_post] = @post
    # 複数画像の一時保存処理
    @temp_files = []
    temp_file_dir = Rails.root.join('tmp', 'uploads') # ディレクトリの調整
    FileUtils.mkdir_p(temp_file_dir) # ディレクトリが存在しない場合に作成
    params[:post][:post_images].each_with_index do |image, index| #受け取った画像データを繰り返し処理で一時ファイルに格納
#      temp_file = Tempfile.new("tempfile_#{index}", temp_file_dir)納
      temp_file = File.open("#{temp_file_dir}/tempfile_#{index}",'w', 0755)
      temp_file.binmode
      temp_file.write(image.read)
      temp_file.rewind
      @temp_files << temp_file
    end
    session[:temporary_image_pathes] = @temp_files.map(&:path) # セッションに一時ファイルへのパスを格納
    redirect_to tag_select_display_posts_path
  end

  def tag_select_display
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
    @temp_image_pathes.each do |image_path| # 一時ファイルからファイルを呼び出しActiveStorageに格納
      file = File.open(image_path)
      blob = ActiveStorage::Blob.create_after_upload!(
        io: file,
        filename: File.basename(image_path),
        content_type: 'image/jpeg'
        )
      @post.post_images.attach(blob)
      File.unlink(image_path)
    end
    @tags = Tag.where(id: session[:tag_ids])
    @post.save
    @tags.each do |tag| # 投稿とタグの中間テーブル作成処理
      tagging = Tagging.new
      tagging.post_id = @post.id
      tagging.tag_id = tag.id
      tagging.save
    end
    session.delete(:new_post) #セッション削除
    session.delete(:tag_ids)
    session.delete(:temporary_image_pathes)
    flash[:notice] = "投稿を作成しました"
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
      temp_file_dir = Rails.root.join('tmp', 'uploads') # ディレクトリを調整
      FileUtils.mkdir_p(temp_file_dir) # ディレクトリが存在しない場合に作成
      params[:post][:post_images].each_with_index do |image, index| # 受け取った画像データを繰り返し処理で一時ファイルに格納
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
    if params[:tag_ids].blank?
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

        # file_data = File.read(image_path)はファイルを消してしまう記述？
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
    flash[:notice] = "投稿を編集しました"
    redirect_to post_path(@post.id)
  end

  def destroy
    @post = Post.find(params[:id])
    taggings = @post.taggings.all
    taggings.destroy_all
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to user_path(current_user.id)
  end

  private

  def post_params
    params.require(:post).permit(:shop_name, :shop_genre, :prefecture, :address, :review, :rate, :reading_status, :user_id, post_images:[])
  end

  def edit_post_params
    params.require(:post).permit(:shop_name, :shop_genre, :prefecture, :address, :review, :rate, :reading_status, :user_id)
  end

  def validate_post
    if (params[:post][:shop_name].empty?) || (params[:post][:address].empty?) || (params[:post][:review].empty?) || (params[:post][:post_images] == nil)
      redirect_to request.referer, notice: "店名、住所、画像、本文を入力してください"
    end
  end

  def validate_post_images
    if params[:post][:post_images] != nil && params[:post][:post_images].size > 5
      redirect_to request.referer, notice: "画像は5枚までです"
    end
  end

  def validate_post_tags
    if params[:tag_ids].size > 10
      redirect_to request.referer, notice: "タグは10個までです"
    end
  end

  def validate_edit_post
    if (params[:post][:shop_name].empty?) || (params[:post][:address].empty?) || (params[:post][:review].empty?)
      redirect_to request.referer, notice: "店名、住所、本文を入力してください"
    end
  end

end

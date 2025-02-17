class ProgramsController < ApplicationController
  before_action :set_program, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[ new create edit update destroy ]
  before_action :email_registered_user, only: %i[ new create edit update destroy ]
  before_action :authorized_user, only: %i[ edit update destroy ]

  def index
    @q = Program.includes(:user).all.order(created_at: :desc).ransack(params[:q])
    @programs = @q.result(distinct: true).page(params[:page]).per(6)
  end

  def show
    @letter = Letter.new
    @letter.radio_name = current_user.name if current_user
    @letter.letterbox_id = params[:letter]&.dig(:letterbox_id)
    @letterboxes = @program.letterboxes.published
  end

  def new
    @program = Program.new
  end

  def edit
    @members = @program.participants
                       .where.not(id: @program.user_id)
                       .page(params[:page])
                       .per(6)
  end

  def create
    @program = current_user.programs.build(program_params)

    if @program.valid?
      if params[:program][:image].present?
        process_and_transform_image(params[:program][:image])
      end

      if @program.save
        current_user.user_participations.create(program: @program)
        flash[:notice] = "番組を作成しました"
        redirect_to @program
      else
        flash.now[:danger] = "番組を作成できませんでした、番組作成フォームを確認してください"
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:danger] = "番組を作成できませんでした、番組作成フォームを確認してください"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    # まず属性の更新のみを行う
    @program.assign_attributes(program_params)

    Rails.logger.debug "@program.valid? => #{@program.valid?}"
    if @program.valid?
      # 画像処理が必要な場合のみ実行
      if params[:program][:image].present?
        process_and_transform_image(params[:program][:image])
      end

      # バリデーションが通った場合のみ保存
      if @program.save
        flash[:notice] = "番組を編集しました"
        redirect_to @program
      else
        flash.now[:danger] = "番組を編集できませんでした、番組編集フォームを確認してください"
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:danger] = "番組を編集できませんでした、番組編集フォームを確認してください"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @program.destroy!
    flash[:notice]= "番組を削除しました"
    redirect_to programs_path, status: :see_other
  end

  private

    def set_program
      @program = Program.find(params[:id])
    end

    def program_params
      params.require(:program).permit(:title, :body, :image)
    end

    def authorized_user
      unless producer?(current_user, @program) || current_user.admin?
        redirect_to(root_url, status: :see_other)
      end
    end

    def process_and_transform_image(image_io)
      require "vips"

      begin
        # 送信された画像を直接処理
        input_image = Vips::Image.new_from_buffer(image_io.tempfile.read, "")
        image_io.tempfile.rewind

        # アスペクト比を維持しながらリサイズ
        processed_image = input_image.thumbnail_image(854,
          height: 480,
          size: :down,
          crop: :none,
        )

        # WebPフォーマットに変換
        output_buffer = processed_image.webpsave_buffer(
          Q: 80,
          effort: 4,
          reduction_effort: 2
        )

        # 新しい一時ファイルを作成して処理済み画像を書き込む
        new_tempfile = Tempfile.new([ "processed", ".webp" ])
        new_tempfile.binmode
        new_tempfile.write(output_buffer)
        new_tempfile.rewind

        # 元のUploadedFileオブジェクトの属性を更新
        image_io.tempfile = new_tempfile
        image_io.original_filename = "#{File.basename(image_io.original_filename, '.*')}.webp"
        image_io.content_type = "image/webp"
      rescue => e
        Rails.logger.error "Image processing error: #{e.message}"
        raise e
      end
    end
end

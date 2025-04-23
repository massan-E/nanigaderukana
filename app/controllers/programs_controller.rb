class ProgramsController < ApplicationController
  before_action :set_program, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[ new create edit update destroy ]
  before_action :email_registered_user, only: %i[ new create edit update destroy ]

  def index
    @q = Program.includes(:user).where(publish: true).order(created_at: :desc).ransack(params[:q])
    @programs = @q.result(distinct: true).page(params[:page]).per(6)
    authorize @programs
  end

  def show
    authorize @program
    @letter = Letter.new
    @letter.radio_name = current_user.name if current_user
    @letter.letterbox_id = params[:letter]&.dig(:letterbox_id)
    @letterboxes = @program.letterboxes.published
  end

  def new
    @program = Program.new
    authorize @program
  end

  def edit
    authorize @program
    @members = @program.participants
                       .where.not(id: @program.user_id)
                       .page(params[:page])
                       .per(6)
  end

  def create
    @program = current_user.programs.build(program_params)
    authorize @program

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

    # ロガー
    # logger.swim("assin_attributes前　ActiveStorage::Attachment.count : #{ActiveStorage::Attachment.count}")
    # ロガー

    @program.assign_attributes(program_params)

    # ロガー
    # logger.swim("assin_attributes後　ActiveStorage::Attachment.count : #{ActiveStorage::Attachment.count}")
    # logger.swim(program_params)
    # logger.swim(@program.image.class)
    # logger.swim(@program.image.inspect)
    # ロガー

    authorize @program

    if @program.valid?

    # ロガー
    # logger.swim("@program.valid?後　ActiveStorage::Attachment.count : #{ActiveStorage::Attachment.count}")
    # ロガー

      # 画像処理が必要な場合のみ実行

      if params[:program][:image].present?
        processed_image = nil
        begin
          # ロガー
          # logger.swim("params[:program][:image].class: #{params[:program][:image].class}")
          # logger.swim("params[:program][:image].inspect: #{params[:program][:image].inspect}")
          # logger.swim "利用可能なメソッド: #{params[:program][:image].methods.sort}"
          # ロガー

          processed_image = process_and_transform_image(params[:program][:image])
          @program.image = processed_image

          # ロガー
          # logger.swim(@program.image.class)
          # logger.swim(@program.image.inspect)
          # logger.swim("params content_type : #{params[:program][:image].content_type}, @program content_type : #{@program.image.content_type}")
          # ロガー

        rescue => e
          flash.now[:danger] = "画像の処理中にエラーが発生しました: #{e.message}"
          return render :edit, status: :unprocessable_entity
        # ensure
        #   # 処理が終わったら一時ファイルをクローズ・削除
        #   if processed_image&.tempfile && !processed_image.tempfile.closed?
        #     processed_image.tempfile.close
        #     processed_image.tempfile.unlink
        #   end
        end
      end

      if @program.save

        # ロガー
        # logger.swim("@program.save後　ActiveStorage::Attachment.count : #{ActiveStorage::Attachment.count}")
        # logger.swim(@program.image.content_type)
        # ロガー

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
    authorize @program
    @program.destroy!
    flash[:notice]= "番組を削除しました"
    redirect_to programs_path, status: :see_other
  end

  private

    def set_program
      @program = Program.find(params[:id])
    end

    def program_params
      params.require(:program).permit(:title, :body, :image, :publish)
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
        # image_io.tempfile = new_tempfile
        # image_io.original_filename = "#{File.basename(image_io.original_filename, '.*')}.webp"
        # image_io.content_type = "image/webp"

        # ロガー
        # logger.swim("tempfile: #{new_tempfile.path}")
        # logger.swim("content_type: image/webp")
        # logger.swim("headers: #{image_io.headers}")
        # ロガー

        # 新しいUploadedFileオブジェクトを作成して返す
        result = ActionDispatch::Http::UploadedFile.new(
          tempfile: new_tempfile,
          type: "image/webp",
          filename: "#{File.basename(image_io.original_filename, '.*')}.webp",
        )

        # 作成されたオブジェクトを確認
        # ロガー
        # logger.swim("Created UploadedFile: #{result.inspect}")
        # logger.swim("Content type: #{result.content_type}")
        # logger.swim("Original filename: #{result.original_filename}")
        # logger.swim result.inspect
        # ロガー

        return result
      rescue => e
        logger.swim "Image processing error: #{e.message}"
        raise e
      end
    end
end

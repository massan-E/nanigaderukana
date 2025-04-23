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
        begin
          @program.image = process_and_transform_image(params[:program][:image])
        rescue => e
          flash.now[:danger] = "画像の処理中にエラーが発生しました: #{e.message}"
          return render :new, status: :unprocessable_entity
        end
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

    authorize @program

    if @program.valid?
      # 画像処理が必要な場合のみ実行

      if params[:program][:image].present?
        begin
          @program.image = process_and_transform_image(params[:program][:image])
        rescue => e
          flash.now[:danger] = "画像の処理中にエラーが発生しました: #{e.message}"
          return render :edit, status: :unprocessable_entity
        end
      end

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

        processed_image = input_image.thumbnail_image(
          # アスペクト比を維持しながらリサイズ
          854,
          height: 480,
          size: :down,
          crop: :none,
        ).webpsave_buffer(
          # WebPフォーマットに変換
          Q: 80,
          effort: 4,
          reduction_effort: 2
        )

        # 新しい一時ファイルを作成して処理済み画像を書き込む
        new_tempfile = Tempfile.new([ "processed", ".webp" ])
        new_tempfile.binmode
        new_tempfile.write(processed_image)
        new_tempfile.rewind

        # 新しいUploadedFileオブジェクトを作成して返す
        result = ActionDispatch::Http::UploadedFile.new(
          tempfile: new_tempfile,
          type: "image/webp",
          filename: "#{File.basename(image_io.original_filename, '.*')}.webp",
        )

        result
      rescue => e
        logger.swim "Image processing error: #{e.message}"
        raise e
      end
    end
end

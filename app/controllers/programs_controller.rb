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
    if @program.save
      current_user.user_participations.create(program: @program)
      resize_image(@program.image) if @program.image.attached?
      flash[:notice]= "番組を作成しました"
      redirect_to @program
    else
      flash.now[:danger] = "番組を作成できませんでした、番組作成フォームを確認してください"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @program.update(program_params)
      resize_image(@program.image) if @program.image.attached?
      flash[:notice]= "番組を編集しました"
      redirect_to @program
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

    def resize_image(image)
      return unless image.attached?

      require "vips"

      # 画像データを読み込み
      blob = image.download
      input_image = Vips::Image.new_from_buffer(blob, "")


      # アスペクト比を維持しながらリサイズ
      processed_image = input_image.thumbnail_image(854,
        height: 480,
        size: :down,        # 画像を縮小のみ行う
        crop: :none,        # クロップを無効化
        linear: true       # より滑らかなスケーリング
      )

      # WebPフォーマットに変換（品質80%）
      output_buffer = processed_image.webpsave_buffer(
        Q: 80,
        effort: 4,         # 圧縮の努力レベル
        reduction_effort: 2 # ファイルサイズ削減の努力レベル
      )

      # 処理した画像を再アタッチ
      image.attach(
        io: StringIO.new(output_buffer),
        filename: "#{image.filename.base}.webp",
        content_type: "image/webp"
      )
    end
end

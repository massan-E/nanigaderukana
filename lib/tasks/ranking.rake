namespace :ranking do
  desc "勢いランキングを更新する"
  task update_ranking: :environment do
    ProgramRanking.delete_all

    rankings = Letter.where(created_at: 2.weeks.ago..)
                      .where.not(program_id: nil)
                      .group(:program_id)
                      .select("program_id, COUNT(id) as letters_count")
                      .order("letters_count DESC")
                      .limit(10)

    ActiveRecord::Base.transaction do
      rankings.each do |result|
        ProgramRanking.create!(
          program_id: result.program_id,
          letters_count: result.letters_count,
          ranked_on: Date.current
        )
      end
    end

    Rails.logger.info "#{Time.current} 時にランキングを更新しました"
    puts "Rankings updated successfully!"
  rescue => e
    Rails.logger.error "ランキングの作成に失敗しました: #{e.message}"
    puts "Error: #{e.message}"
    raise e
  end
end

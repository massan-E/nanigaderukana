module ApplicationHelper
  def default_meta_tags
    {
      site: "Music Hour",
      title: "お便り募集＆管理用ツール「Music Hour」",
      reverse: true,
      charset: "utf-8",
      description: "「Music Hour」はラジオ番組へのお便りをイメージしたツールです。リスナーからのお便りを募集し、配信などで公開するためのお手伝いをします。",
      canonical: request.original_url,
      separator: "|",
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: request.original_url,
        image: image_url("ogp.png"), # 配置するパスやファイル名によって変更すること
        local: "ja-JP"
      },
      # Twitter用の設定を個別で設定する
      twitter: {
        card: "summary_large_image", # Twitterで表示する場合は大きいカードにする
        site: "@massan_E", # アプリの公式Twitterアカウントがあれば、アカウント名を書く
        image: image_url("ogp.png") # 配置するパスやファイル名によって変更すること
      }
    }
  end
end

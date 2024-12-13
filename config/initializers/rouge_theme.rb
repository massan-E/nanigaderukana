# config/initializers/rouge_theme.rb
require 'rouge'
require 'fileutils'

rouge_theme = Rouge::Themes::MonokaiSublime.render(scope: '.highlight')

# stylesheets ディレクトリにRougeのスタイルシートを作成
FileUtils.mkdir_p(Rails.root.join('app', 'assets', 'stylesheets'))
File.write(Rails.root.join('app', 'assets', 'stylesheets', '_rouge.scss'), rouge_theme)
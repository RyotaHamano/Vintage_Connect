namespace :cleanup_upload_files do
  desc '一時ファイルに保管されている画像ファイルを毎日昼12時に削除する'
  task :cleanup_upload_files => :environment do
    Dir["tmp/uploads/*"].each do |file|
      if File.mtime(file) < 1.day.ago
        File.delete(file)
      end
    end
  end
end

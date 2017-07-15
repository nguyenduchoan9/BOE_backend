CarrierWave.configure do |config|
  config.ignore_integrity_errors = true
  config.ignore_processing_errors = true
  config.ignore_download_errors = true
  # config.asset_host = "http://localhost:3000"
end
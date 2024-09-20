Clamby.configure({
  daemonize: true,
  config_file: Rails.root.join('config/clamav.conf')
})

Hydra::Works.default_system_virus_scanner = Nims::VirusScanner

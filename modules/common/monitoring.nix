{
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "systemd"
    ];
    listenAddress = "127.0.0.1";
    port = 9100;
  };
}

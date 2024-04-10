{ ... }: {
  services = {
    unbound = {
      enable = true;
      settings = {
        server = { interface = [ "127.0.0.1" ]; };
        forward-zone = [{
          name = ".";
          forward-addr = "1.1.1.1";
        }];
      };
    };
  };
}

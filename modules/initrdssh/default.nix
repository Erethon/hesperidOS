{
  boot.initrd = {
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 2222;
        hostKeys = [
          "/etc/ssh/initrd_ssh_host_ed25519_key"
        ];
        authorizedKeys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDb/e7O6zcnEhaGz2JyzWCP7rWCCO0ZWwZvHeSYtQ6D384ZssDFupvoEIhVvPnuYbl3/jzXN69D/gm2w95hv82swUOvSbOhxhqga5HEZh5doC2RjAIchOaAqSOKPKQfaSZroZ+l+eUtcm8I4L6+xdUtSMaNndHQwWa2mllhZ21jrF6msublVuvy/ATjwHLdLd1MAORoYXKja84cejj0cQdVbyv36vqQmBeuU87//4mw45/IIpef3t6UjGjTAyUVGih2LQdX0Y4rghFwt1pc1x4oQxp4hThCQFYikTUtAw1CLFRjfnaU1KyCTc9akV6rf0NowChsENj1TvczTQg9tjlHA28rhpP6W2gN9buHzU/tG13pkBC/0PLmUtN7U95nAPNEYbjxQAbGKU9/lWICU0EEYoHFb+qhRiCdM0fek/9jj0F84ur4yWDQ9xtJKAg/mtNF3VyFbV86pmXnlTVdCzeW8eIU6BHOtc29i5BIXPUp9A2jELSY3FraTF2a7c2WCO6L43sJRwKl6U78QGpSHXSUN+fJIgK1MrvjEtoKRKHMeVdTtkqhabQqySaDl92PH6cVFHrLMhCB0YG5HFdsWoS+KxrRpCA4y9709+tNq5ulqgw/eD7RPbDP1SmHOEHSowF3A8DhfL3Sw1xoHQsr+/ghUFWvoylr+knDf+/PM0UCbw=="
        ];
      };
    };
  };
}

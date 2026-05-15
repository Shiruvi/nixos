{
  pkgs,
  ...
}:
{
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      samsung-unified-linux-driver # Официальный закрытый драйвер для большинства МФУ/принтеров Samsung
      # Альтернативный открытый драйвер для старых моделей (SPL)
    ];
  };
}

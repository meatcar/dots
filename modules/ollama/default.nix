{ pkgs, ... }:
{
  # No HSA_OVERRIDE_GFX_VERSION: both GPUs (gfx1010 eGPU, gfx1103 iGPU) are
  # native rocBLAS targets here, and a single override value can't cover both,
  # so setting it (as commonly advised for these chips) breaks one of them.
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;

    # DynamicUser default: StateDirectory=ollama lands in /var/lib/private,
    # already persisted whole by ../impermanence. Don't add a dedicated
    # persistence entry for it -- StateDirectory setup fails with
    # 238/STATE_DIRECTORY if its path is itself a mountpoint.

    environmentVariables = {
      # Without this, ollama drops integrated GPUs from consideration, so
      # embedding builds silently fall back to CPU whenever the eGPU is undocked.
      OLLAMA_IGPU_ENABLE = "1";

      # Deliberately NOT "-1": that pins weights in VRAM indefinitely, blocking
      # the eGPU from suspending. 5m keeps a long embedding build resident
      # (the timer resets per request) while letting idle periods release it.
      OLLAMA_KEEP_ALIVE = "5m";

      # agentsview sends several documents per server concurrently; without
      # matching parallelism here they serialize in ollama's queue.
      OLLAMA_NUM_PARALLEL = "4";
    };

    loadModels = [ "qwen3-embedding:0.6b" ];
  };
}

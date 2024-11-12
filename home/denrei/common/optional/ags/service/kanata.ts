import icons from "lib/icons";
import { bash } from "lib/utils";

class Kanata extends Service {
  static {
    Service.register(
      this,
      {},
      {
        enabled: ["boolean"],
      },
    );
  }

  #enabled = true;

  async start() {
    if (!this.#enabled) return;

    bash("sudo systemctl start kanata-laptop.service");

    this.#enabled = true;
    this.changed("enabled");
    Utils.notify({
      iconName: icons.fallback.video,
      summary: "Kanata",
      body: "Kanata started",
    });
  }

  async stop() {
    if (!this.#enabled) return;

    bash("sudo systemctl stop kanata-laptop.service");

    this.#enabled = false;
    this.changed("enabled");

    Utils.notify({
      iconName: icons.fallback.video,
      summary: "Kanata",
      body: "Kanata stopped",
    });
  }
}

const kanata = new Kanata();
Object.assign(globalThis, { recorder: kanata });
export default kanata;

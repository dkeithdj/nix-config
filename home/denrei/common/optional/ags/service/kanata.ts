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

  enabled =
    Utils.exec("systemctl is-active kanata-laptop.service") === "active"
      ? true
      : false;

  async start() {
    if (this.enabled) return;

    try {
      await bash("systemctl start kanata-laptop.service");

      this.enabled = true;
      this.changed("enabled");
      Utils.notify({
        summary: "Kanata",
        body: "Kanata started",
      });
    } catch (error) {
      Utils.notify({
        summary: "Kanata",
        body: `error: ${error}`,
      });
    }
  }

  async stop() {
    if (!this.enabled) return;
    try {
      await bash("systemctl stop kanata-laptop.service");

      this.enabled = false;
      this.changed("enabled");

      Utils.notify({
        summary: "Kanata",
        body: "Kanata stopped",
      });
    } catch (error) {
      Utils.notify({
        summary: "Kanata",
        body: `error: ${error}`,
      });
    }
  }
}

const kanata = new Kanata();
Object.assign(globalThis, { kanata: kanata });
export default kanata;

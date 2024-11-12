import { bash } from "lib/utils";

const HOST = Utils.exec("hostname");
const service =
  HOST === "altair" ? "kanata-altair.service" : "kanata-canopus.service";

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
    Utils.exec(`systemctl is-active ${service}`) === "active" ? true : false;

  async start() {
    if (this.enabled) return;

    try {
      await bash(`systemctl start ${service}`);

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
      await bash(`systemctl stop ${service}`);

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

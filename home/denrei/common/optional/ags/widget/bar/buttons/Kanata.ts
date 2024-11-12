import icons from "lib/icons";
import PanelButton from "../PanelButton";
import kanata from "service/kanata";
import options from "options";

const { scheme, dark, light } = options.theme;

const primary =
  scheme.value === "dark" ? dark.primary.bg.value : light.primary.bg.value;
const error =
  scheme.value === "dark" ? dark.error.bg.value : light.error.bg.value;

export default () =>
  PanelButton({
    class_name: "kanata",
    on_clicked: () => (kanata.enabled ? kanata.stop() : kanata.start()),
    visible: true,
    child: Widget.Icon({
      icon: icons.keyboard.keyboard,
      css: kanata.bind("enabled").as((v) => `color: ${v ? primary : error}`),
    }),
  });

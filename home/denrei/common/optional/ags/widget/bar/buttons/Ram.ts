import PanelButton from "../PanelButton";
import icons from "lib/icons";

const ram = Variable([], {
  poll: [
    2000,
    "free -h",
    (out) =>
      out
        ?.split("\n")
        ?.find((line) => line.includes("Mem:"))
        ?.split(/\s+/)
        ?.splice(1, 2)
        .map((a: string) => a.replace(/Gi/, "")) ?? ["1", "1"],
  ],
});

export default () =>
  PanelButton({
    window: "ram",
    child: Widget.Box({
      children: [
        Widget.Icon(icons.system.ram),
        Widget.Label({
          justification: "center",
          label: ram.bind().as(([total, usage]) => ` ${usage}/${total} GB`),
        }),
      ],
    }),
  });

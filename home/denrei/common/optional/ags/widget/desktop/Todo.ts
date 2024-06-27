import options from "options";

export default (monitor: number) =>
  Widget.Window({
    monitor,
    layer: "bottom",
    name: `desktop${monitor}`,
    class_name: "desktop",
    anchor: ["top", "bottom", "left", "right"],
    exclusivity: "ignore",
    layer: "bottom",
    child: Widget.Box({
      css: options.theme.dark.primary.bg.bind().as(
        (c) => `
            transition: 500ms;
            background-color: ${c}`,
      ),
      children: [
        Widget.Box({
          class_name: "wallpaper",
          expand: true,
          vpack: "center",
          hpack: "center",
          label: "wiget",
        }),
        Widget.Button({
          child: Widget.Label("click me!"),
          onClicked: () => print("hello"),
        }),
      ],
    }),
  });

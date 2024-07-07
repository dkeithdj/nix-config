import icons from "lib/icons";
const WINDOW_NAME = "clipboard";

const cursor = Variable("");
const ClipItem = (clip) =>
  Widget.Button({
    on_clicked: () => {
      Utils.execAsync([
        "zsh",
        "-c",
        `cliphist decode "${clip.split("\t")[0]}" | wl-copy`,
      ]).then((out) => {
        App.closeWindow(WINDOW_NAME);
      });
      App.closeWindow(WINDOW_NAME);
    },
    attribute: { clip },
    child: Widget.Box({
      children: [
        Widget.Label({
          class_name: "title",
          label: clip,
          xalign: 0,
          vpack: "center",
          truncate: "end",
        }),
      ],
    }),
  });

const Applauncher = ({ width = 500, height = 500, spacing = 12 }) => {
  // List of clipboard items
  let applications = Utils.exec("cliphist list").split("\n").map(ClipItem);

  // Container holding the buttons
  const list = Widget.Box({
    vertical: true,
    children: applications,
    spacing,
  });

  // Repopulate the box with clipboard items
  function repopulate() {
    applications = Utils.exec("cliphist list").split("\n").map(ClipItem);
    list.children = applications;
  }

  // Search entry
  const entry = Widget.Entry({
    hexpand: true,
    primary_icon_name: icons.ui.search,

    // To select the first item on Enter
    on_accept: () => {
      const results = applications.filter((item) => item.visible);

      if (results[0]) {
        Utils.execAsync([
          "zsh",
          "-c",
          `cliphist decode "${results[0].attribute.clip.split("\t")[0]}" | wl-copy`,
        ]).then((out) => {
          App.closeWindow(WINDOW_NAME);
        });
      }
      App.closeWindow(WINDOW_NAME);
    },

    // Filter out the list based on search text
    on_change: ({ text }) => {
      applications.forEach((item) => {
        item.visible = item.attribute.clip.match(text ?? "");
      });
    },
  });
  // const fixed = Widget.Fixed({
  //   setup(self) {
  //     self.put(Widget.Label("hello"), 0, 0);
  //     self.put(Widget.Label("hello"), 50, 50);
  //   },
  // });
  const container = Widget.Fixed({ expand: true });
  const event = Widget.EventBox({
    child: container,
    on_primary_click: async () => {
      const pos = await Hyprland.messageAsync("cursorpos");
      const { x, y } = JSON.parse(pos);
      const box = Widget.Box();
      container.put(box, x, y);
      container.show_all();
      cursor.value = `aa`;
    },
  });
  return Widget.Box({
    vertical: true,
    css: `margin: ${spacing * 2}px;`,
    class_name: "launcher",
    children: [
      event,
      Widget.Label({ label: cursor.bind().as((v) => `Cursor: ${v}`) }),
      entry,
      Widget.Separator({ vertical: true, css: "margin: 6px 0" }),

      // Wrap the list in a scrollable container
      Widget.Scrollable({
        hscroll: "never",
        css: `min-width: ${width}px; min-height: ${height}px;`,
        child: list,
      }),
    ],
    setup: (self) =>
      self.hook(App, (_, windowName, visible) => {
        if (windowName !== WINDOW_NAME) return;

        // When the applauncher shows up
        if (visible) {
          repopulate();
          entry.text = "";
          entry.grab_focus();
        }
      }),
  });
};

// There needs to be only one instance
export default () =>
  Widget.Window({
    name: WINDOW_NAME,
    setup: (self) =>
      self.keybind("Escape", () => {
        App.closeWindow(WINDOW_NAME);
      }),
    visible: false,
    keymode: "on-demand",
    child: Applauncher({
      width: 500,
      height: 200,
      spacing: 12,
    }),
  });

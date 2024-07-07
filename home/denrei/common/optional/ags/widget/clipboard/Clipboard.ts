const WINDOW_NAME = "clipboard";

const ClipItem = (clip) =>
  Widget.Button({
    on_clicked: () => {
      Utils.exec(`echo ${clip} | cliphist decode | wl-copy`);
      App.closeWindow(WINDOW_NAME);
    },
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
  // list of application buttons
  let applications = Utils.exec("cliphist list").split("\n").map(ClipItem);

  // container holding the buttons
  const list = Widget.Box({
    vertical: true,
    children: applications,
    spacing,
  });

  // repopulate the box, so the most frequent apps are on top of the list
  function repopulate() {
    applications = Utils.exec("cliphist list").split("\n").map(ClipItem);
    list.children = applications;
  }

  // search entry
  const entry = Widget.Entry({
    hexpand: true,
    css: `margin-bottom: ${spacing}px;`,

    // to launch the first item on Enter
    on_accept: ({ text }) => {
      const results = applications.filter((item) =>
        item.child.children[0].label.includes(text),
      );
      if (results.length > 0) {
        Utils.exec(
          `echo ${results[0].child.children[0].label} | cliphist decode | wl-copy`,
        );
        App.closeWindow(WINDOW_NAME);
      }
    },

    // filter out the list
    on_change: ({ text }) => {
      applications.forEach((item) => {
        item.visible = item.child.children[0].label.includes(text);
      });
    },
  });

  return Widget.Box({
    vertical: true,
    css: `margin: ${spacing * 2}px;`,
    children: [
      entry,

      // wrap the list in a scrollable
      Widget.Scrollable({
        hscroll: "never",
        css: `min-width: ${width}px;` + `min-height: ${height}px;`,
        child: list,
      }),
    ],
    setup: (self) =>
      self.hook(App, (_, windowName, visible) => {
        if (windowName !== WINDOW_NAME) return;

        // when the applauncher shows up
        if (visible) {
          repopulate();
          entry.text = "";
          entry.grab_focus();
        }
      }),
  });
};

// there needs to be only one instance
export default () =>
  Widget.Window({
    name: WINDOW_NAME,
    setup: (self) =>
      self.keybind("Escape", () => {
        App.closeWindow(WINDOW_NAME);
      }),
    visible: false,
    keymode: "exclusive",
    child: Applauncher({
      width: 500,
      height: 500,
      spacing: 12,
    }),
  });

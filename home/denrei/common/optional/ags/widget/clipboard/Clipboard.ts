const { query } = await Service.import("applications");
const WINDOW_NAME = "applauncher";

const AppItem = (app) =>
  Widget.Button({
    on_clicked: () => {
      App.closeWindow(WINDOW_NAME);
      Utils.exec(`app | cliphist decode | wl-copy`);
      // app.launch();
    },
    attribute: { app },
    child: Widget.Box({
      children: [
        Widget.Icon({
          icon: app.icon_name || "",
          size: 42,
        }),
        Widget.Label({
          class_name: "title",
          label: app.name,
          xalign: 0,
          vpack: "center",
          truncate: "end",
        }),
      ],
    }),
  });
const ClipItem = (clip) =>
  Widget.Button({
    on_clicked: () => {
      Utils.exec(`${clip} | cliphist decode | wl-copy`);
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
  // let applications = query("").map(AppItem);
  let applications = Utils.exec("cliphist list").split("\n").map(ClipItem);
  // let applications = Utils.exec("cliphist list");
  // let applications = Utils.exec("cliphist list").map(AppItem);

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
    on_accept: () => {
      // make sure we only consider visible (searched for) applications
      // const results = applications.filter((item) => item.visible);
      const results = applications
        .filter((e) => e.split("\t")[0] === item)
        .forEach((e) => e);
      // if (results[0]) {
      //   App.toggleWindow(WINDOW_NAME);
      //   results[0].attribute.app.launch();
      // }
      if (results) {
        App.toggleWindow(WINDOW_NAME);
        Utils.exec(`${results} | cliphist decode | wl-copy`);
        // results.attribute.app.launch();
      }
    },

    // filter out the list
    on_change: ({ text }) =>
      applications.forEach((item) => {
        item.visible = item.attribute.app.match(text ?? "");
      }),
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

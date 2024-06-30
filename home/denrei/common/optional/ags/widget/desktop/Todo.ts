import GLib from "gi://GLib?version=2.0";
import options from "options";
const { bar, quicksettings } = options;

// cliphist list | <input here> | cliphist decode | wl-copy

const arr = Utils.exec("cliphist list");

const arst = JSON.parse(
  Utils.readFile(`${GLib.get_user_data_dir()}/errands/data.json`),
);
const reactData = Variable(arst);

Utils.monitorFile(`${GLib.get_user_data_dir()}/errands/data.json`, () => {
  if (true)
    reactData.value = JSON.parse(
      Utils.readFile(`${GLib.get_user_data_dir()}/errands/data.json`),
    );
});
// const bb = JSON.parse(aa).tasks[0].text;
const bb = reactData.bind().as((e) => e.emitter.value.tasks);
// const bb = arst.tasks;

const task = (item) =>
  Widget.Button({
    css: `padding: 7px; gap: 7px;`,
    child: Widget.Label(item.text),
  });

export default () =>
  Widget.Window({
    layer: "background",
    name: "todo",
    anchor: ["bottom", "right"],
    margins: [10, 10, 10, 10],
    exclusivity: "ignore",
    keymode: "exclusive",
    setup: (w) => w.keybind("Escape", () => App.closeWindow(name)),
    visible: false,

    child: Widget.Box({
      vertical: true,
      spacing: 8,
      class_name: "quicksettings vertical",
      css: quicksettings.width
        .bind()
        .as((w) => `margin: 7px; min-width: ${w}px;`),
      // children: bb.map((cc) => task(cc)),
      children: [Widget.Label(arr)],
      // children: bb.map((item) => Widget.Label(item)),
      // children: [
      //   // Widget.Label(ll),
      //   bb.map(item => Widget.Label(item.text)
      //   // Widget.Label(bb),
      // ],
    }),
  });

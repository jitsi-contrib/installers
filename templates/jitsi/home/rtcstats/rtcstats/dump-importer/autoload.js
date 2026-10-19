// rtcstats (demo only)
// Load the dump given as "?dump=<name>" into the viewer, the same way as
// selecting the file by hand.
const name = new URLSearchParams(window.location.search).get('dump');

if (name) {
    const url = '/rtcstats-dumps/files/' + encodeURIComponent(name);
    const response = await fetch(url);
    const file = new File([await response.blob()], name);
    const transfer = new DataTransfer();
    const input = document.getElementById('import');

    transfer.items.add(file);
    input.files = transfer.files;
    input.dispatchEvent(new Event('change'));
}

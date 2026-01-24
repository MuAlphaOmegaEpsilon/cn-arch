function page_visit()
{
 const pathname_array = window.location.pathname.split("/");
 const resource_name  = pathname_array[pathname_array.length - 1];
 return "Visita " + (resource_name === "" ? "index" : resource_name.slice(0, resource_name.length - 5));
}

function ntfy(title)
{
 if (window.location.protocol == "file:" || window.location.host.startsWith("192.168."))
  return Promise.resolve();
 const body_text = "UserAgent: " + navigator.userAgent + "\n" +
                   "Platform: " + navigator.platform   + "\n" +
                   "Languages: " + navigator.language  + "\n" +
                   "Display: " + screen.width + "x" + screen.height + "\n" +
                   "HW: " + navigator.hardwareConcurrency + " threads, " + (navigator.deviceaMemory ?? "--") + "GB\n" +
                   "Storage:   " + (1 - storage.usage / storage.quota) * 100 + "%"
 return fetch("https://ntfy.sh/cnarchstudio",
              { method: "POST",
                headers: { "Title": title },
                body: body_text
              }
             ).catch((error) => {});
}
ntfy(page_visit());

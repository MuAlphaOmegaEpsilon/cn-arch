function page_visit()
{
 const pathname_array = window.location.pathname.split("/");
 const resource_name  = pathname_array[pathname_array.length - 1];
 return "Visita " + (resource_name === "" ? "index" : resource_name.slice(0, resource_name.length - 5));
}

async function ntfy(title)
{
 if (window.location.protocol == "file:" || window.location.host.startsWith("192.168."))
  return Promise.resolve();
 storage_promise = navigator.storage.estimate()
 body_text =  "UserAgent: " + navigator.userAgent + "\n"
 body_text += "Platform: " + navigator.platform  + "\n"
 body_text += "Languages: " + navigator.language  + "\n"
 body_text += "Display: " + screen.width + "x" + screen.height + "\n"
 body_text += "HW: " + navigator.hardwareConcurrency + " threads, " + (navigator.deviceMemory ?? "--") + "GB\n"
 storage = await storage_promise
 body_text += "Storage:   " + (1 - storage.usage / storage.quota) * 100 + "%"
 return fetch("https://ntfy.sh/cnarchstudio",
              { method: "POST",
                headers: { "Title": title },
                body: body_text
              }
             ).catch((error) => {});
}
ntfy(page_visit());

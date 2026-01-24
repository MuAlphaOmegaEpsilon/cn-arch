function page_visit()
{
 let pathname = window.location.pathname;
 if (pathname === "/")
  return "index";
 if (pathname.endsWith("/"))
  pathname = pathname.substring(0, pathname.length - 1);
 const pathname_array = window.location.pathname.split("/");
 const resource_name  = pathname_array[pathname_array.length - 1];
 resource_name.slice(0, resource_name.length - 5);
}

function ntfy(title)
{
 if (window.location.protocol == "file:" || window.location.host.startsWith("192.168."))
  return Promise.resolve();
 return fetch("https://ntfy.sh/cnarchstudio",
              { method: "POST",
                headers: { "Title": title },
                body: "UserAgent: " + navigator.userAgent + "\n" +
                      "Platform:  " + navigator.platform  + "\n" +
                      "Languages: " + navigator.language  + "\n" +
                      "Display:   " + screen.width + "x" + screen.height + "\n" +
                      "Hardware:  " + navigator.hardwareConcurrency + " threads, " + (navigator.deviceMemory ?? "--") + "GB\n"
              }
             ).catch((error) => {});
}
ntfy(page_visit());

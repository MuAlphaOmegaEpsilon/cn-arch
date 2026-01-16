const CONTENT  = document.getElementsByTagName('main')[0];
const PAGER    = document.getElementById("pager");
const PROJECTS = CONTENT.children;
const PROJECTS_PER_PAGE = 10;
var current_page_idx    =  0;

function setPage(page_index, visibility)
{	for (var i = 0; i < PROJECTS_PER_PAGE; i++)
	{	var prj_idx = page_index * PROJECTS_PER_PAGE + i;
		if (prj_idx >= PROJECTS.length)
			return;
		PROJECTS[prj_idx].style.display = visibility;
	}
}
function goToPage(index)
{	if (index === current_page_idx)
		return;
	console.log("goToPage(" + index + ")")
	setPage(current_page_idx, "none");
	PAGER.children[current_page_idx].removeAttribute("class");
	current_page_idx = index;
	setPage(current_page_idx, "inherit");
	PAGER.children[current_page_idx].setAttribute("class", "active");
	CONTENT.scrollIntoView();
}

var pages = Math.ceil(PROJECTS.length / PROJECTS_PER_PAGE);
for (var i = 0; i < pages;)
{	var node = document.createElement("page");
	node.setAttribute("onclick", "goToPage(" + i++ + ")");
	node.appendChild(document.createTextNode(i));
	PAGER.appendChild(node);
}
setPage(0, "inherit");
PAGER.children[0].setAttribute("class", "active");

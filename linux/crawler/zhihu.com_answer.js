var target = document.querySelectorAll(".AnswerCard")[0];

if (!target) {
    target = document.querySelectorAll(".RichContent")[0];
}

// var target = document.querySelectorAll(".MoreAnswers")[0];

var text = target.innerText.replace(/\n+/g, "\n");
var data = `${document.URL}\n\n${text}`;

var link = document.createElement("a");
link.href = `data:text/plain;charset=utf8,${data.replace(/\n/g, "%0D%0A")}\n`;

link.download = `zhihu.com_${document.title}.md`;
link.click();

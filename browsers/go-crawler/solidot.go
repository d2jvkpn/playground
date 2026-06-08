package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"regexp"
	"strings"
	"time"

	"github.com/PuerkitoBio/goquery"
)

func main() {
	if len(os.Args) == 1 {
		QueryList()
		os.Exit(0)
	}

	for _, s := range os.Args[1:] {
		QueryStory(s)
	}
}

func QueryStory(id string) {
	url := "https://www.solidot.org/story?sid=" + id
	var res *http.Response
	var err error

	if res, err = http.Get(url); err != nil {
		log.Fatal(err)
	}

	var doc *goquery.Document
	if doc, err = goquery.NewDocumentFromReader(res.Body); err != nil {
		log.Fatal(err)
	}

	story := ">>> " + strings.TrimSpace(doc.Find("div.bg_htit").Eq(0).Text())
	re := regexp.MustCompile("[\\d]+年[\\d]+月[\\d]+日 [\\d]+时[\\d]+分")
	release := re.FindString(doc.Find("div.talk_time").Text())
	story += "\n" + release + "  " + url

	re = regexp.MustCompile("[\\s]{2,}")
	content := doc.Find("div.p_mainnew").Eq(0).Text()
	content = strings.Replace(strings.TrimSpace(content), "\n", "", -1)
	story += "\n    " + string(re.ReplaceAll([]byte(content), []byte(" ")))
	fmt.Printf("%s\n\n", story)
}

func QueryList() {
	client := &http.Client{}
	req, _ := http.NewRequest("GET", "https://www.solidot.org/?", nil)

	req.Header.Set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "+
		"AppleWebKit/537.36 (KHTML, like Geko) chrom/61.0.3163.100")

	req.Header.Set("Referer", "https://www.solidot.org")

	var res *http.Response
	var err error

	if res, err = client.Do(req); err != nil {
		log.Println(err)
	}
	defer res.Body.Close()

	if res.StatusCode != 200 {
		log.Fatalf("%d %s\n", res.StatusCode, res.Status)
	}

	var doc *goquery.Document
	if doc, err = goquery.NewDocumentFromReader(res.Body); err != nil {
		log.Fatal(err)
	}

	fmt.Println(time.Now().Format("## 2006-01-02T15:05:05-07:00") + "  " +
		"https://www.solidot.org/story?sid=")

	var s *goquery.Selection
	var txt, tag string
	re := regexp.MustCompile("[\\s]{2,}")

	doc.Find("div.block_m").Each(func(i int, sel *goquery.Selection) {
		s = sel.Find("div.bg_htit").Find("a").Last()
		txt, _ = s.Attr("href")
		tag, _ = sel.Find("div.talk_time").Eq(0).Find("a").Eq(0).Attr("title")

		fmt.Printf("%s  %s  [%s]\n    \n", strings.TrimLeft(txt, "/story?sid="),
			string(re.ReplaceAll([]byte(s.Text()), []byte(" "))), tag)
	})
}

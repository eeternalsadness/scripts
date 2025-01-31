/*
Copyright © 2025 Bach Nguyen <69bnguyen@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
package cmd

import (
	"fmt"
  "os"
  "encoding/json"
  "net/url"
  "text/tabwriter"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"github.com/eeternalsadness/jira/util"
)

// issuesCmd represents the issues command
var issuesCmd = &cobra.Command{
	Use:   "issues",
	Short: "get Jira issues that are assigned to the current user (you)",
	Run: func(cmd *cobra.Command, args []string) {
    jql := "assignee = currentuser() AND status NOT IN (Done, Rejected, Cancelled)"
    fields := "summary,status"

    // get jira config
    var jira util.Jira
    viper.Unmarshal(&jira)

    // call api
    path := fmt.Sprintf("rest/api/3/search/jql?jql=%s&fields=%s&fieldsByKeys=true", url.QueryEscape(jql), url.QueryEscape(fields))
    resp := jira.CallApi(path, "GET")

    // parse json data
    var issues util.Issues
    json.Unmarshal(resp, &issues)

    //var data map[string]interface{}
    //json.Unmarshal(resp, &data)
    //jsonOutput, _ := json.Marshal(data)
    //fmt.Println(string(jsonOutput))
    // print out issues
    w := tabwriter.NewWriter(os.Stdout, 0, 0, 2, ' ', 0)
    fmt.Fprintln(w, "Issue\tStatus\t")
    for _, issue := range issues.Issues {
      fmt.Fprintf(w, "[%s] %s\t%s\t\n", issue.Key, issue.Fields.Summary, issue.Fields.Status.StatusCategory.Name)
    }
    w.Flush()
	},
}

func init() {
	getCmd.AddCommand(issuesCmd)
}

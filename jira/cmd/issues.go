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
  "encoding/json"
  "net/url"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"github.com/eeternalsadness/jira/util"
)

// issuesCmd represents the issues command
var issuesCmd = &cobra.Command{
	Use:   "issues",
	Short: "Get Jira issues that are assigned to the current user (you)",
	Run: func(cmd *cobra.Command, args []string) {
    jql := "assignee = currentuser()"

    // get jira config
    var jira util.Jira
    viper.Unmarshal(&jira)

    // call api
    path := fmt.Sprintf("rest/api/3/search/jql?jql=%s", url.QueryEscape(jql))
    resp := jira.CallApi(path, "GET")

    // parse json data
    var data map[string]interface{}
    json.Unmarshal(resp, &data)
    fmt.Println(data)
	},
}

func init() {
	getCmd.AddCommand(issuesCmd)
}

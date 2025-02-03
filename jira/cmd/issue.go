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
	"log"
	"os"
	"text/tabwriter"

	"github.com/spf13/cobra"
)

// getIssueCmd represents the issues command when called by the get command
var getIssueCmd = &cobra.Command{
	Use:   "issue",
	Short: "Get your current Jira issues",
	Long: `Get Jira issues that are assigned to the current user (you).
Issues with status 'Done', 'Rejected', or 'Cancelled' are not returned.`,
	Run: func(cmd *cobra.Command, args []string) {
		issues, err := jira.GetAssignedIssues()
		if err != nil {
			log.Fatal(fmt.Errorf("failed to get assigned issues: %w", err))
		}

		// print out issues
		w := tabwriter.NewWriter(os.Stdout, 0, 0, 2, ' ', 0)
		fmt.Fprintln(w, "ID\tIssue\tStatus\t")
		for _, issue := range issues {
			fmt.Fprintf(w, "%s\t[%s] %s\t%s\t\n", issue.Id, issue.Key, issue.Title, issue.Status)
		}
		w.Flush()
	},
}

// createIssueCmd represents the issues command when called by the create command
var createIssueCmd = &cobra.Command{
	Use:   "issue",
	Short: "Create a Jira issue",
	// Long: ``,
	Run: func(cmd *cobra.Command, args []string) {
		createIssue()
	},
}

func createIssue() {
	fmt.Println("creating issue")
}

func init() {
	getCmd.AddCommand(getIssueCmd)
	createCmd.AddCommand(createIssueCmd)
}

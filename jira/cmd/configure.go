/*
Copyright © 2025 Bach Nguyen

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
  "bufio"
  "os"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

// configureCmd represents the configure command
var configureCmd = &cobra.Command{
	Use:   "configure",
	Short: "Configure Jira domain & credentials",
	Long: `Configure Jira domain, email address, and API token`,
	Run: func(cmd *cobra.Command, args []string) {
    configure()
	},
}

func configure() {
  reader := bufio.NewReader(os.Stdin)

  // check for overwrite
	if err := viper.ReadInConfig(); err == nil {
    fmt.Printf("Config file exists at '%s'\n", viper.ConfigFileUsed())
    fmt.Print("Overwrite config file? [y/n]: ")
    overwrite, _ := reader.ReadString('\n')
    overwrite = overwrite[:len(overwrite) - 1]

    if overwrite != "y" {
      if overwrite != "n" {
        fmt.Println("Input must be 'y' or 'n'.")
      }
      return
    }
  }

  // create config folder
  os.MkdirAll(cfgPath, 0755)

  // configure jira domain
  fmt.Print("Enter the Jira domain [example.atlassian.net]: ")
  domain, _ := reader.ReadString('\n')
  domain = domain[:len(domain) - 1]
  viper.Set("domain", domain)

  // configure jira email
  fmt.Print("Enter the email address used for Jira [example@example.com]: ")
  email, _ := reader.ReadString('\n')
  email = email[:len(email) - 1]
  viper.Set("email", email)

  fmt.Print("Enter the Jira API token: ")
  token, _ := reader.ReadString('\n')
  token = token[:len(token) - 1]
  viper.Set("token", token)

  viper.WriteConfigAs(fmt.Sprintf("%s/config.yaml", cfgPath))
}

func init() {
	rootCmd.AddCommand(configureCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// configureCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// configureCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}

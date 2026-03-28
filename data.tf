#
# HashiCorp Random
#

resource "random_integer" "main" {
  min = 1
  max = 9999
}

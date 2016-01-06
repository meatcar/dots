

// Base16 OceanicNext dark - simple terminal color setup
// https://github.com/voronianski/oceanic-next-color-scheme
static const char *colorname[] = {
	/* Normal colors */
	"#1B2B34", /*  0: Base 00 - Black   */
	"#EC5f67", /*  1: Base 08 - Red     */
	"#99C794", /*  2: Base 0B - Green   */
	"#FAC863", /*  3: Base 0A - Yellow  */
	"#6699CC", /*  4: Base 0D - Blue    */
	"#C594C5", /*  5: Base 0E - Magenta */
	"#5FB3B3", /*  6: Base 0C - Cyan    */
	"#C0C5CE", /*  7: Base 05 - White   */

	/* Bright colors */
	"#65737E", /*  8: Base 03 - Bright Black */
	"#EC5f67", /*  9: Base 08 - Red          */
	"#99C794", /* 10: Base 0B - Green        */
	"#FAC863", /* 11: Base 0A - Yellow       */
	"#6699CC", /* 12: Base 0D - Blue         */
	"#C594C5", /* 13: Base 0E - Magenta      */
	"#5FB3B3", /* 14: Base 0C - Cyan         */
	"#D8DEE9", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#F99157", /* 16: Base 09 */
	"#AB7967", /* 17: Base 0F */
	"#343D46", /* 18: Base 01 */
	"#4F5B66", /* 19: Base 02 */
	"#A7ADBA", /* 20: Base 04 */
	"#CDD3DE", /* 21: Base 06 */

	[255] = 0,

	[256] = "#C0C5CE", /* default fg: Base 05 */
	[257] = "#1B2B34", /* default bg: Base 00 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;




// Base16 Railscasts light - simple terminal color setup
// Ryan Bates (http://railscasts.com)
static const char *colorname[] = {
	/* Normal colors */
	"#2b2b2b", /*  0: Base 00 - Black   */
	"#da4939", /*  1: Base 08 - Red     */
	"#a5c261", /*  2: Base 0B - Green   */
	"#ffc66d", /*  3: Base 0A - Yellow  */
	"#6d9cbe", /*  4: Base 0D - Blue    */
	"#b6b3eb", /*  5: Base 0E - Magenta */
	"#519f50", /*  6: Base 0C - Cyan    */
	"#e6e1dc", /*  7: Base 05 - White   */

	/* Bright colors */
	"#5a647e", /*  8: Base 03 - Bright Black */
	"#da4939", /*  9: Base 08 - Red          */
	"#a5c261", /* 10: Base 0B - Green        */
	"#ffc66d", /* 11: Base 0A - Yellow       */
	"#6d9cbe", /* 12: Base 0D - Blue         */
	"#b6b3eb", /* 13: Base 0E - Magenta      */
	"#519f50", /* 14: Base 0C - Cyan         */
	"#f9f7f3", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#cc7833", /* 16: Base 09 */
	"#bc9458", /* 17: Base 0F */
	"#272935", /* 18: Base 01 */
	"#3a4055", /* 19: Base 02 */
	"#d4cfc9", /* 20: Base 04 */
	"#f4f1ed", /* 21: Base 06 */

	[255] = 0,

	[256] = "#3a4055", /* default fg: Base 02 */
	[257] = "#f9f7f3", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;



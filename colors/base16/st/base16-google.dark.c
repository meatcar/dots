

// Base16 Google dark - simple terminal color setup
// Seth Wright (http://sethawright.com)
static const char *colorname[] = {
	/* Normal colors */
	"#1d1f21", /*  0: Base 00 - Black   */
	"#CC342B", /*  1: Base 08 - Red     */
	"#198844", /*  2: Base 0B - Green   */
	"#FBA922", /*  3: Base 0A - Yellow  */
	"#3971ED", /*  4: Base 0D - Blue    */
	"#A36AC7", /*  5: Base 0E - Magenta */
	"#3971ED", /*  6: Base 0C - Cyan    */
	"#c5c8c6", /*  7: Base 05 - White   */

	/* Bright colors */
	"#969896", /*  8: Base 03 - Bright Black */
	"#CC342B", /*  9: Base 08 - Red          */
	"#198844", /* 10: Base 0B - Green        */
	"#FBA922", /* 11: Base 0A - Yellow       */
	"#3971ED", /* 12: Base 0D - Blue         */
	"#A36AC7", /* 13: Base 0E - Magenta      */
	"#3971ED", /* 14: Base 0C - Cyan         */
	"#ffffff", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#F96A38", /* 16: Base 09 */
	"#3971ED", /* 17: Base 0F */
	"#282a2e", /* 18: Base 01 */
	"#373b41", /* 19: Base 02 */
	"#b4b7b4", /* 20: Base 04 */
	"#e0e0e0", /* 21: Base 06 */

	[255] = 0,

	[256] = "#c5c8c6", /* default fg: Base 05 */
	[257] = "#1d1f21", /* default bg: Base 00 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


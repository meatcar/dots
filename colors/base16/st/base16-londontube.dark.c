

// Base16 London Tube dark - simple terminal color setup
// Jan T. Sott
static const char *colorname[] = {
	/* Normal colors */
	"#231f20", /*  0: Base 00 - Black   */
	"#ee2e24", /*  1: Base 08 - Red     */
	"#00853e", /*  2: Base 0B - Green   */
	"#ffd204", /*  3: Base 0A - Yellow  */
	"#009ddc", /*  4: Base 0D - Blue    */
	"#98005d", /*  5: Base 0E - Magenta */
	"#85cebc", /*  6: Base 0C - Cyan    */
	"#d9d8d8", /*  7: Base 05 - White   */

	/* Bright colors */
	"#737171", /*  8: Base 03 - Bright Black */
	"#ee2e24", /*  9: Base 08 - Red          */
	"#00853e", /* 10: Base 0B - Green        */
	"#ffd204", /* 11: Base 0A - Yellow       */
	"#009ddc", /* 12: Base 0D - Blue         */
	"#98005d", /* 13: Base 0E - Magenta      */
	"#85cebc", /* 14: Base 0C - Cyan         */
	"#ffffff", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#f386a1", /* 16: Base 09 */
	"#b06110", /* 17: Base 0F */
	"#1c3f95", /* 18: Base 01 */
	"#5a5758", /* 19: Base 02 */
	"#959ca1", /* 20: Base 04 */
	"#e7e7e8", /* 21: Base 06 */

	[255] = 0,

	[256] = "#d9d8d8", /* default fg: Base 05 */
	[257] = "#231f20", /* default bg: Base 00 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


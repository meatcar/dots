

// Base16 Hopscotch light - simple terminal color setup
// Jan T. Sott
static const char *colorname[] = {
	/* Normal colors */
	"#322931", /*  0: Base 00 - Black   */
	"#dd464c", /*  1: Base 08 - Red     */
	"#8fc13e", /*  2: Base 0B - Green   */
	"#fdcc59", /*  3: Base 0A - Yellow  */
	"#1290bf", /*  4: Base 0D - Blue    */
	"#c85e7c", /*  5: Base 0E - Magenta */
	"#149b93", /*  6: Base 0C - Cyan    */
	"#b9b5b8", /*  7: Base 05 - White   */

	/* Bright colors */
	"#797379", /*  8: Base 03 - Bright Black */
	"#dd464c", /*  9: Base 08 - Red          */
	"#8fc13e", /* 10: Base 0B - Green        */
	"#fdcc59", /* 11: Base 0A - Yellow       */
	"#1290bf", /* 12: Base 0D - Blue         */
	"#c85e7c", /* 13: Base 0E - Magenta      */
	"#149b93", /* 14: Base 0C - Cyan         */
	"#ffffff", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#fd8b19", /* 16: Base 09 */
	"#b33508", /* 17: Base 0F */
	"#433b42", /* 18: Base 01 */
	"#5c545b", /* 19: Base 02 */
	"#989498", /* 20: Base 04 */
	"#d5d3d5", /* 21: Base 06 */

	[255] = 0,

	[256] = "#5c545b", /* default fg: Base 02 */
	[257] = "#ffffff", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;



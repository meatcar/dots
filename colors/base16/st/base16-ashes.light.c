

// Base16 Ashes light - simple terminal color setup
// Jannik Siebert (https://github.com/janniks)
static const char *colorname[] = {
	/* Normal colors */
	"#1C2023", /*  0: Base 00 - Black   */
	"#C7AE95", /*  1: Base 08 - Red     */
	"#95C7AE", /*  2: Base 0B - Green   */
	"#AEC795", /*  3: Base 0A - Yellow  */
	"#AE95C7", /*  4: Base 0D - Blue    */
	"#C795AE", /*  5: Base 0E - Magenta */
	"#95AEC7", /*  6: Base 0C - Cyan    */
	"#C7CCD1", /*  7: Base 05 - White   */

	/* Bright colors */
	"#747C84", /*  8: Base 03 - Bright Black */
	"#C7AE95", /*  9: Base 08 - Red          */
	"#95C7AE", /* 10: Base 0B - Green        */
	"#AEC795", /* 11: Base 0A - Yellow       */
	"#AE95C7", /* 12: Base 0D - Blue         */
	"#C795AE", /* 13: Base 0E - Magenta      */
	"#95AEC7", /* 14: Base 0C - Cyan         */
	"#F3F4F5", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#C7C795", /* 16: Base 09 */
	"#C79595", /* 17: Base 0F */
	"#393F45", /* 18: Base 01 */
	"#565E65", /* 19: Base 02 */
	"#ADB3BA", /* 20: Base 04 */
	"#DFE2E5", /* 21: Base 06 */

	[255] = 0,

	[256] = "#565E65", /* default fg: Base 02 */
	[257] = "#F3F4F5", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;



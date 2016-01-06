

// Base16 Bespin dark - simple terminal color setup
// Jan T. Sott
static const char *colorname[] = {
	/* Normal colors */
	"#28211c", /*  0: Base 00 - Black   */
	"#cf6a4c", /*  1: Base 08 - Red     */
	"#54be0d", /*  2: Base 0B - Green   */
	"#f9ee98", /*  3: Base 0A - Yellow  */
	"#5ea6ea", /*  4: Base 0D - Blue    */
	"#9b859d", /*  5: Base 0E - Magenta */
	"#afc4db", /*  6: Base 0C - Cyan    */
	"#8a8986", /*  7: Base 05 - White   */

	/* Bright colors */
	"#666666", /*  8: Base 03 - Bright Black */
	"#cf6a4c", /*  9: Base 08 - Red          */
	"#54be0d", /* 10: Base 0B - Green        */
	"#f9ee98", /* 11: Base 0A - Yellow       */
	"#5ea6ea", /* 12: Base 0D - Blue         */
	"#9b859d", /* 13: Base 0E - Magenta      */
	"#afc4db", /* 14: Base 0C - Cyan         */
	"#baae9e", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#cf7d34", /* 16: Base 09 */
	"#937121", /* 17: Base 0F */
	"#36312e", /* 18: Base 01 */
	"#5e5d5c", /* 19: Base 02 */
	"#797977", /* 20: Base 04 */
	"#9d9b97", /* 21: Base 06 */

	[255] = 0,

	[256] = "#8a8986", /* default fg: Base 05 */
	[257] = "#28211c", /* default bg: Base 00 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;




// Base16 harmonic16 light - simple terminal color setup
// Jannik Siebert (https://github.com/janniks)
static const char *colorname[] = {
	/* Normal colors */
	"#0b1c2c", /*  0: Base 00 - Black   */
	"#bf8b56", /*  1: Base 08 - Red     */
	"#56bf8b", /*  2: Base 0B - Green   */
	"#8bbf56", /*  3: Base 0A - Yellow  */
	"#8b56bf", /*  4: Base 0D - Blue    */
	"#bf568b", /*  5: Base 0E - Magenta */
	"#568bbf", /*  6: Base 0C - Cyan    */
	"#cbd6e2", /*  7: Base 05 - White   */

	/* Bright colors */
	"#627e99", /*  8: Base 03 - Bright Black */
	"#bf8b56", /*  9: Base 08 - Red          */
	"#56bf8b", /* 10: Base 0B - Green        */
	"#8bbf56", /* 11: Base 0A - Yellow       */
	"#8b56bf", /* 12: Base 0D - Blue         */
	"#bf568b", /* 13: Base 0E - Magenta      */
	"#568bbf", /* 14: Base 0C - Cyan         */
	"#f7f9fb", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#bfbf56", /* 16: Base 09 */
	"#bf5656", /* 17: Base 0F */
	"#223b54", /* 18: Base 01 */
	"#405c79", /* 19: Base 02 */
	"#aabcce", /* 20: Base 04 */
	"#e5ebf1", /* 21: Base 06 */

	[255] = 0,

	[256] = "#405c79", /* default fg: Base 02 */
	[257] = "#f7f9fb", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;



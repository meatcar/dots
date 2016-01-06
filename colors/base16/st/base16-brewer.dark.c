

// Base16 Brewer dark - simple terminal color setup
// Timothée Poisot (http://github.com/tpoisot)
static const char *colorname[] = {
	/* Normal colors */
	"#0c0d0e", /*  0: Base 00 - Black   */
	"#e31a1c", /*  1: Base 08 - Red     */
	"#31a354", /*  2: Base 0B - Green   */
	"#dca060", /*  3: Base 0A - Yellow  */
	"#3182bd", /*  4: Base 0D - Blue    */
	"#756bb1", /*  5: Base 0E - Magenta */
	"#80b1d3", /*  6: Base 0C - Cyan    */
	"#b7b8b9", /*  7: Base 05 - White   */

	/* Bright colors */
	"#737475", /*  8: Base 03 - Bright Black */
	"#e31a1c", /*  9: Base 08 - Red          */
	"#31a354", /* 10: Base 0B - Green        */
	"#dca060", /* 11: Base 0A - Yellow       */
	"#3182bd", /* 12: Base 0D - Blue         */
	"#756bb1", /* 13: Base 0E - Magenta      */
	"#80b1d3", /* 14: Base 0C - Cyan         */
	"#fcfdfe", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#e6550d", /* 16: Base 09 */
	"#b15928", /* 17: Base 0F */
	"#2e2f30", /* 18: Base 01 */
	"#515253", /* 19: Base 02 */
	"#959697", /* 20: Base 04 */
	"#dadbdc", /* 21: Base 06 */

	[255] = 0,

	[256] = "#b7b8b9", /* default fg: Base 05 */
	[257] = "#0c0d0e", /* default bg: Base 00 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


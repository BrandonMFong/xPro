/*
 * UserConfigTemplate.h
 *
 *  Created on: Nov 22, 2021
 *      Author: brandonmfong
 */

#ifndef USERCONFIGTEMPLATE_H
#define USERCONFIGTEMPLATE_H

/**
 * This is the template we use when we create a user config from the executable
 */
#define USER_CONFIG_TEMPLATE \
	"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n"\
	"<xPro xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n"\
		"\t<Directories>\n"\
				"\t\t<Directory key=\"\">\n"\
					"\t\t\t<Value username=\"\"></Value>\n"\
				"\t\t</Directory>\n"\
		"\t</Directories>\n"\
	"</xPro>\n"

#define ENV_CONFIG_TEMPLATE \
	"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n"\
	"<xPro xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n"\
		"\t<!-- List of users -->\n"\
		"\t<!-- Set active to 'true' to activate the config. Only one user can be active. -->\n"\
		"\t<Users>\n"\
			"\t\t<User active=\"false\">\n"\
				"\t\t\t<!-- Unique user name.  Prohibited characters: '.' -->\n"\
				"\t\t\t<username></username>\n"\
				"\t\t\t<!-- Absolute path to your config file -->\n"\
				"\t\t\t<ConfigPath></ConfigPath>\n"\
			"\t\t</User>\n"\
		"\t</Users>\n"\
	"</xPro>\n"\

#endif /* USERCONFIGTEMPLATE_H */

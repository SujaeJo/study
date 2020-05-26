// [H2006] 멀티유저 파일시스템

#ifndef _CRT_SECURE_NO_WARNINGS
#define _CRT_SECURE_NO_WARNINGS
#endif

#include <stdio.h>

void init();
void createUser(char userName[], char groupName[]);
int createDirectory(char userName[], char path[], char directoryName[], int permission);
int createFile(char userName[], char path[], char fileName[], char fileExt[]);
int find(char userName[], char pattern[]);

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////

static int run(int Ans)
{
	int n;
	scanf("%d", &n);
	init();

	char userName[8];
	char groupName[8];
	char path[500];
	char directoryName[8];
	int permission;
	int expectedAnswer;
	char fileName[8];
	char fileExt[8];
	char pattern[500];

	for (int i = 0; i < n; i++)
	{
		int type;
		scanf("%d", &type);

		if (type == 1)
		{
			scanf("%s %s", userName, groupName);

			createUser(userName, groupName);
		}
		else if (type == 2)
		{
			scanf("%s %s %s %d", userName, path, directoryName, &permission);

			int userAnswer = createDirectory(userName, path, directoryName, permission);
			scanf("%d", &expectedAnswer);
			if (userAnswer != expectedAnswer)
				Ans = 0;
		}
		else if (type == 3)
		{
			scanf("%s %s %s %s", userName, path, fileName, fileExt);

			int userAnswer = createFile(userName, path, fileName, fileExt);
			scanf("%d", &expectedAnswer);
			if (userAnswer != expectedAnswer)
				Ans = 0;
		}
		else if (type == 4)
		{
			scanf("%s %s", userName, pattern);

			int userAnswer = find(userName, pattern);
			scanf("%d", &expectedAnswer);
			if (userAnswer != expectedAnswer)
				Ans = 0;
		}
	}

	return Ans;
}

int main()
{
	setbuf(stdout, NULL);
	// freopen("sample_input.txt", "r", stdin);

	int T, Ans;
	scanf("%d %d", &T, &Ans);

	for (int tc = 1; tc <= T; tc++)
	{
		printf("#%d %d\n", tc, run(Ans));
	}

	return 0;
}








void mstrcpy(char dst[], const char src[]) {
	int c = 0;
	while ((dst[c] = src[c]) != 0) 
		++c;
}

int mstrcmp(const char str1[], const char str2[]) {
	int c = 0;
	while (str1[c] != 0 && str1[c] == str2[c]) 
		++c;
	return str1[c] - str2[c];
}

int numOfUser;
char User[20][8];
int numOfGroup;
char Group[10][8];

char getGidFromUid[20];






struct Node
{
	int  type; // 0 is directory, 1 is file


	char Name[8];
	char Ext[8];


	int  uid;
	int  gid;
	int  permission;


	int  siblingnext;
	int  childroot;
};


int  nodeIndex = 0;
Node node[10001];


int findUser(char userName[]) // if userName is already exist, return uid. else, return -1
{
	for (int i = 0; i < numOfUser; ++i)
		if (mstrcmp(User[i], userName) == 0)
			return i;
	return -1;
}


int findGroup(char groupName[]) // if groupName is already exist, return gid. else, return -1
{
	for (int i = 0; i < numOfGroup; ++i)
		if (mstrcmp(Group[i], groupName) == 0)
			return i;
	return -1;
}


int getWord(char path[], int p, char word[])
{
	int idx = 0;


	while (path[p] != '\0' && path[p] != '/')
	{
		word[idx] = path[p];
		++idx; 
		++p;
	}


	word[idx] = '\0';


	if (path[p] == '/') 
		++p;


	return p;
}


int getWord2(char path[], int p, char word[])
{
	int idx = 0;


	while (path[p] != '\0' && path[p] != '.')
	{
		word[idx] = path[p];
		++idx; ++p;
	}


	word[idx] = '\0';


	if (path[p] == '.') ++p;


	return p;
}


void init()
{
	mstrcpy(User[0], "admin");
	mstrcpy(Group[0], "admin");
	getGidFromUid[0] = 0;


	node[0].type = 0;
	node[0].Name[0] = '\0';
	node[0].Ext[0] = '\0';
	node[0].uid = 0;
	node[0].gid = 0;
	node[0].permission = 2;
	node[0].siblingnext = 0;
	node[0].childroot = 0;


	numOfUser = 1;
	numOfGroup = 1;
	nodeIndex = 1;
}


void createUser(char userName[], char groupName[])
{
	printf("@@@ createUser start @@@\n");
	mstrcpy(User[numOfUser], userName); // add userName to User[]


	int gid = findGroup(groupName);
	printf("groupName[%s], gid[%d]\n", groupName, gid);
	if (gid == -1) // there is no groupName in Goup[], then add it to the Group[]
	{
		mstrcpy(Group[numOfGroup], groupName);
		gid = numOfGroup++;
		printf("groupName[%s] is not exist, so we are add it. gid[%d]\n", groupName, gid);
	}
	else 
	{
		printf("groupName[%s] is already exist. gid[%d]\n", groupName, gid);
	}

	printf("userName[%s], uid[%d], gid[%d] \n", userName, numOfUser, gid);

	getGidFromUid[numOfUser++] = gid;
	
	printf("@@@ createUser end @@@\n");
}


int createDirectory(char userName[], char path[], char directoryName[], int permission)
{
	printf("@@@ createDirectory start @@@\n");
	int uid = findUser(userName);
	int gid = getGidFromUid[uid];
	printf("uid[%d], gid[%d]\n", uid, gid);

	int cur = 0;


	int p1 = 1;
	while (path[p1] != '\0')
	{
		printf("path[%d] is %c\n", p1, path[p1]);
		char word[8];
		p1 = getWord(path, p1, word);
		printf("p1[%d], cur[%d]\n", p1, cur);

		int p = node[cur].childroot;
		while (p)
		{
			printf("1 p[%d]\n", p);
			Node &node_c = node[p];
			printf("node_c.type[%d], node_c.Name[%s], word[%s]\n", node_c.type, node_c.Name, word);
			if (node_c.type == 0 && mstrcmp(node_c.Name, word) == 0)
			{
				cur = p;
				if (node[cur].permission == 0 && node[cur].uid != uid) {
					printf("return 0 because uid is not same\n");
					return 0; // fail
				}
				if (node[cur].permission == 1 && node[cur].gid != gid) {
					printf("return 0 because gid is not same\n");
					return 0; // fail
				}
				printf("break!\n");
				break;
			}
			p = node[p].siblingnext;
			printf("2 p[%d]\n", p);
		}
	}

	printf("create directory to nodeIndex[%d], cur[%d]\n", nodeIndex, cur);
	node[nodeIndex].type = 0;
	mstrcpy(node[nodeIndex].Name, directoryName);
	node[nodeIndex].Ext[0] = '\0';
	node[nodeIndex].uid = uid;
	node[nodeIndex].gid = gid;
	node[nodeIndex].permission = permission;
	node[nodeIndex].childroot = 0;
	node[nodeIndex].siblingnext = node[cur].childroot;
	printf("nodeIndex is %d, node[nodeIndex].siblingnext is :%d\n", nodeIndex, node[nodeIndex].siblingnext);

	node[cur].childroot = nodeIndex++;
	printf("node[%d].childroot is %d\n", cur, node[cur].childroot);

	return 1;
	printf("@@@ createDirectory end @@@\n");
}




int createFile(char userName[], char path[], char fileName[], char fileExt[])
{
	printf("@@@ createFile start @@@\n");
	int uid = findUser(userName);
	int gid = getGidFromUid[uid];


	int cur = 0;


	int p1 = 1;
	while (path[p1] != '\0')
	{
		printf("path[%d] is %c\n", p1, path[p1]);
		char word[8];
		p1 = getWord(path, p1, word);
		printf("p1[%d], cur[%d]\n", p1, cur);

		int p = node[cur].childroot;
		while (p)
		{
			printf("1 p[%d]\n", p);
			Node &node_c = node[p];
			printf("node_c.type[%d], node_c.Name[%s], word[%s]\n", node_c.type, node_c.Name, word);
			if (node_c.type == 0 && mstrcmp(node_c.Name, word) == 0)
			{
				cur = p;
				if (node[cur].permission == 0 && node[cur].uid != uid) {
					printf("return 0 because uid is not same\n");
					return 0;
				}
				if (node[cur].permission == 1 && node[cur].gid != gid) {
					printf("return 0 because gid is not same\n");
					return 0;
				}
				printf("break!\n");
				break;
			}
			p = node[p].siblingnext;
			printf("2 p[%d]\n", p);
		}
	}

	printf("create file to node[%d], cur[%d]\n", nodeIndex, cur);
	node[nodeIndex].type = 1;
	mstrcpy(node[nodeIndex].Name, fileName);
	mstrcpy(node[nodeIndex].Ext, fileExt);
	node[nodeIndex].uid = 0;
	node[nodeIndex].gid = 0;
	node[nodeIndex].permission = 2;
	node[nodeIndex].childroot = 0;
	printf("cur is %d, node[cur].childroot is :%d\n", cur, node[cur].childroot);
	node[nodeIndex].siblingnext = node[cur].childroot;
	printf("nodeIndex is %d, node[nodeIndex].siblingnext is :%d\n", nodeIndex, node[nodeIndex].siblingnext);

	node[cur].childroot = nodeIndex++;
	printf("node[%d].childroot is %d\n", cur, node[cur].childroot);
	printf("@@@ createFile end @@@\n");
	return 1;
}


int find(int uid, int gid, char pattern[], int p, int e, int cur)
{
	int ret = 0;


	if (p == e)
	{
		char File[8], Ext[8];
		p = getWord2(pattern, p, File);
		mstrcpy(Ext, pattern + p);


		if (File[0] == '*' && Ext[0] == '*')
		{
			int w = node[cur].childroot;
			while (w)
			{
				Node &node_c = node[w];
				if (node_c.type == 1)
					++ret;
				w = node[w].siblingnext;
			}
		}
		else if (File[0] == '*')
		{
			int w = node[cur].childroot;
			while (w)
			{
				Node &node_c = node[w];
				if (node_c.type == 1 && mstrcmp(node_c.Ext, Ext) == 0)
					++ret;
				w = node[w].siblingnext;
			}
		}
		else if (Ext[0] == '*')
		{
			int w = node[cur].childroot;
			while (w)
			{
				Node &node_c = node[w];
				if (node_c.type == 1 && mstrcmp(node_c.Name, File) == 0)
					++ret;
				w = node[w].siblingnext;
			}
		}
		else
		{
			int w = node[cur].childroot;
			while (w)
			{
				Node &node_c = node[w];
				if (node_c.type == 1 && mstrcmp(node_c.Name, File) == 0 && mstrcmp(node_c.Ext, Ext) == 0)
				{
					++ret;
					break;
				}
				w = node[w].siblingnext;
			}
		}
		return ret;
	}
	else
	{
		char word[8];
		p = getWord(pattern, p, word);


		if (word[0] == '*')
		{
			int w = node[cur].childroot;
			while (w)
			{
				Node &node_c = node[w];
				if (node_c.type == 0 && (node_c.permission == 2 ||
					(node_c.permission == 0 && node_c.uid == uid) ||
					(node_c.permission == 1 && node_c.gid == gid)))
					ret += find(uid, gid, pattern, p, e, w);
				w = node[w].siblingnext;
			}
		}
		else
		{
			int w = node[cur].childroot;
			while (w)
			{
				Node &node_c = node[w];
				if (node_c.type == 0 && mstrcmp(node_c.Name, word) == 0)
				{
					if (node_c.permission == 0 && node_c.uid != uid)
						break;
					if (node_c.permission == 1 && node_c.gid != gid)
						break;
					ret = find(uid, gid, pattern, p, e, w);
					break;
				}
				w = node[w].siblingnext;
			}
		}


		return ret;
	}


	return 0;
}


int find(char userName[], char pattern[])
{
	printf("@@@ find start @@@\n");
	int uid = findUser(userName);
	int gid = getGidFromUid[uid];


	int e = 0;


	while (pattern[e] != '\0') 
		++e;

	while (pattern[e] != '/')
		--e;
	++e;

	printf("e is %d\n", e);
	int ret = find(uid, gid, pattern, 1, e, 0);

	printf("@@@ find end @@@\n");
	return ret;
}

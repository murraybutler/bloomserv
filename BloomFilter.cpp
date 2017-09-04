#include <string>
#include <fstream>
#include <stdint.h>
#include "BloomFilter.h"
#include "city.h"

using namespace std;

BloomFilter::BloomFilter()
:pbv(NULL)
{
	this->pbv = new BV();
	this->pbv->reset();
}

BloomFilter::BloomFilter(const char* in_path)
:pbv(NULL)
{
	ifstream in(in_path);
	string str((istreambuf_iterator<char>(in)),
			istreambuf_iterator<char>());
	this->pbv = new BV(str);
	in.close();
}

BloomFilter::~BloomFilter()
{
	if(this->pbv)
	{
		delete pbv;	
	}
}

void BloomFilter::Dump(const char* out_path)
{
	ofstream out(out_path);
	out<<this->pbv->to_string();
	out.close();
}

void BloomFilter::Add(const string key)
{
	uint32_t seed = 0;
	for(size_t i=0; i<M; i++)
	{
		uint32_t pos = 0;
		//MurmurHash3_x86_32(key.c_str(), key.length(), seed, &pos);
    pos = CityHash32(key.c_str(), key.length());
		seed = pos;
		pos %= LEN;
		this->pbv->set(pos);
	}
}

bool BloomFilter::Test(const string key)
{
	uint32_t seed = 0;
	for(size_t i=0; i<M; i++)
	{
		uint32_t pos = 0;
		//MurmurHash3_x86_32(key.c_str(), key.length(), seed, &pos);
    pos = CityHash32(key.c_str(), key.length());
		seed = pos;
		pos %= LEN;
		if(!this->pbv->test(pos))
		{
			return false;
		}
	}
	return true;
}

bool BloomFilter::TestAndAdd(const string key)
{
	if(this->Test(key))
	{
		return true;	
	}
	else
	{
		this->Add(key);
		return false;
	}
}

####        \\      Search Multiple Queries at One Time        //       ####
params = [
    {
    'q': 'Digital Silk Road AND DSR',
    'lang': 'en',
    'to_rank': 10000,
    'page_size': 100,
    'from': '3 years ago', 
    'page': 1
    },
    {
    'q': 'Digital Silk Road AND China',
    'lang': 'en',
    'to_rank': 10000,
    'page_size': 100,
    'from': '3 years ago', 
    'page': 1
    },
    {
    'q': 'Digital Silk Road AND Malaysia',
    'lang': 'en',
    'to_rank': 10000,
    'page_size': 100,
    'from': '3 years ago', 
    'page': 1
    },
    {
    'q': 'Digital Silk Road AND Indonesia',
    'lang': 'en',
    'to_rank': 10000,
    'page_size': 100,
    'from': '3 years ago', 
    'page': 1
    },
    {
    'q': 'Digital Silk Road AND Philippines',
    'lang': 'en',
    'to_rank': 10000,
    'page_size': 100,
    'from': '3 years ago', 
    'page': 1
    },
    {
    'q': 'Digital Silk Road AND Geopolitics',
    'lang': 'en',
    'to_rank': 10000,
    'page_size': 100,
    'from': '3 years ago', 
    'page': 1
    }
]




# Variable to store all found news articles, mp stands for "multiple queries"
all_news_articles_mp = []

# Infinite loop which ends when all articles are extracted
for separated_param in params:

    print(f'Query in use => {str(separated_param)}')
    
    while True:
        # Wait for 1 second between each call
        time.sleep(1)

        # GET Call from previous section enriched with some logs
        response = requests.get(base_url, headers=headers, params=separated_param)
        results = json.loads(response.text.encode())
        if response.status_code == 200:
            print(f'Done for page number => {separated_param["page"]}')


            # Adding your parameters to each result to be able to explore afterwards
            for i in results['articles']:
                i['used_params'] = str(separated_param)


            # Storing all found articles
            all_news_articles_mp.extend(results['articles'])

            # Ensuring to cover all pages by incrementing "page" value at each iteration
            separated_param['page'] += 1
            if separated_param['page'] > results['total_pages']:
                print("All articles have been extracted")
                break
            else:
                print(f'Proceed extracting page number => {separated_param["page"]}')
        else:
            print(results)
            print(f'ERROR: API call failed for page number => {separated_param["page"]}')
            break

print(f'Number of extracted articles => {str(len(all_news_articles_mp))}')




# Define variables
unique_ids = []
all_news_articles = []

# Iterate on each article and check whether we saw this _id before
for article in all_news_articles_mp:
    if article['_id'] not in unique_ids:
        unique_ids.append(article['_id'])
        all_news_articles.append(article)

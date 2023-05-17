import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_bloc/Blocs/AppFuntions/app_functions_cubit.dart';
import 'package:gdsc_bloc/Data/Models/resource_model.dart';
import 'package:gdsc_bloc/Data/providers.dart';
import 'package:google_fonts/google_fonts.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  final searchController = TextEditingController();
  Future? resultsLoaded;
  List<Resource> allResults = [];
  List<Resource> resultsList = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      onSearchChanged();
    });
  }

  void onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    List<Resource> showResults = [];

    if (searchController.text.isNotEmpty) {
      for (var tripSnapshot in allResults) {
        if (tripSnapshot.title!
            .toLowerCase()
            .contains(searchController.text.toLowerCase())) {
          showResults.add(tripSnapshot);
        }
      }
    } else {
      showResults = List.from(allResults);
    }
    setState(() {
      resultsList = showResults;
    });
  }

  getResourcesList() async {
    var data = await Providers().getResources();
    setState(() {
      allResults = data;
    });
    searchResultsList();

    return data;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getResourcesList();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => AppFunctionsCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  await getResourcesList();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Your Resources",
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: const Color(0xff000000),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 49,
                              padding:
                                  const EdgeInsets.only(left: 15, right: 1),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Colors.grey[500]!,
                                    width: 0.8,
                                  )),
                              child: TextFormField(
                                controller: searchController,
                                // onFieldSubmitted: (value) {
                                //   context
                                //       .read<AppFunctionsCubit>()
                                //       .searchResource(query: value);
                                // },
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: const Color(0xff000000),
                                ),
                                decoration: InputDecoration(
                                  hintText: "Search for resource eg. Flutter",
                                  border: InputBorder.none,
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xff666666),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          BlocBuilder<AppFunctionsCubit, AppFunctionsState>(
                            builder: (context, state) {
                              return state is AlignmentChanged ? Container(
                                  height: 59,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 0.8,
                                      )),
                                  child:
                                          state.alignment == false
                                      ? IconButton(
                                        splashColor: Colors.white10,
                                        splashRadius: 1,
                                          onPressed: () {
                                            context
                                                .read<AppFunctionsCubit>()
                                                .changeAlignment(align: false);
                                          },
                                          icon: const Icon(
                                            Icons.list,
                                            color: Colors.black,
                                          ),
                                        )
                                      : IconButton(
                                        splashColor: Colors.white10,
                                        splashRadius: 1,
                                          onPressed: () {
                                            context
                                                .read<AppFunctionsCubit>()
                                                .changeAlignment(align: true);
                                          },
                                          icon: const Icon(
                                            Icons.window,
                                            color: Colors.black,
                                          ),
                                        )) : Container(
                                  height: 59,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 0.8,
                                      )),
                                  child: IconButton(
                                        splashColor: Colors.white10,
                                        splashRadius: 1,
                                          onPressed: () {
                                            context
                                                .read<AppFunctionsCubit>()
                                                .changeAlignment(align: false);
                                          },
                                          icon: const Icon(
                                            Icons.window,
                                            color: Colors.black,
                                          ),
                                        ));
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocBuilder<AppFunctionsCubit, AppFunctionsState>(
                        builder: (context, state) {
                          return state is AlignmentChanged?  Flexible(
                            fit: FlexFit.loose,
                            child: GridView.builder(
                                itemCount: resultsList.length,
                                gridDelegate:
                                     SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: state.alignment == true
                                      ? 2
                                      : 3,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                ),
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: height * 0.08,
                                    width: width * 0.42,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 106, 81, 81),
                                        width: 0.4,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        opacity: 0.5,
                                        image: CachedNetworkImageProvider(
                                          resultsList[index].imageUrl!,
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: height * 0.06,
                                          width: width * 0.5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            color:
                                                Colors.black.withOpacity(0.75),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Center(
                                              child: Text(
                                                resultsList[index].title!,
                                                overflow: TextOverflow.clip,
                                                maxLines: 2,
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13,
                                                  color:
                                                      const Color(0xffffffff),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ) : Flexible(
                            fit: FlexFit.loose,
                            child: GridView.builder(
                                itemCount: resultsList.length,
                                gridDelegate:
                                    const  SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:  2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                ),
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: height * 0.08,
                                    width: width * 0.42,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 106, 81, 81),
                                        width: 0.4,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        opacity: 0.5,
                                        image: CachedNetworkImageProvider(
                                          resultsList[index].imageUrl!,
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: height * 0.06,
                                          width: width * 0.5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            color:
                                                Colors.black.withOpacity(0.75),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Center(
                                              child: Text(
                                                resultsList[index].title!,
                                                overflow: TextOverflow.clip,
                                                maxLines: 2,
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13,
                                                  color:
                                                      const Color(0xffffffff),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ) ;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ));
      }),
    );
  }
}

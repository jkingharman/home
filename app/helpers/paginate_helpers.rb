module Helpers
  module Paginate
    def paginate(objs, page = 0, per = 5)
      total = objs.size
      lower_bound = (page * per)
      upper_bound = ((page + 1) * per)

      paginated = objs[lower_bound...upper_bound]

      {paginated: paginated, total: total, lower_bound: lower_bound, upper_bound: upper_bound,
      page: page}
    end
  end
end

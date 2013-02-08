Entries = new Meteor.Collection("entries")

if (Meteor.isClient)
  Template.raffle.entries = -> Entries.find()

  Template.raffle.events =
    'submit #new_entry': (event) ->
      event.preventDefault()
      Entries.insert(name: $('#new_entry_name').val())
      $('#new_entry_name').val('').focus()

    'click #draw': ->
      winner = _.shuffle(Entries.find(winner: {$ne: true}).fetch())[0]
      if winner
        Entries.update({recent: true}, {$set: {recent:false}}, {multi: true})
        Entries.update(winner._id, $set: {winner: true, recent: true})

      Meteor.flush() #Use flush to update DOM before checking for winners

      clearWinners = confirm("Everyone's a winner! Clear all winners?") if Entries.find({winner: true}).count() == Entries.find().count()
      if clearWinners
        Entries.update({winner: true}, {$set: {winner:false}}, {multi: true})


    'click #clear_people': ->
      Entries.remove({})

    'click #clear_winners': ->
      Entries.update({winner: true}, {$set: {winner:false}}, {multi: true})

    'click .delete_person': ->
      Entries.remove({_id: this._id})

  Template.entry.winner_class = ->
    if this.recent then 'highlight' else ''

